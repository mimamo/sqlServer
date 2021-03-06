USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[frx_insert_acct_code]    Script Date: 12/21/2015 16:01:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[frx_insert_acct_code]
	@CpnyID char(10),
	@Acct char(10),
	@Sub char(24)
AS
  DECLARE @EntityNum smallint
  DECLARE @MaxSegs int
  DECLARE @NatSegLen tinyint
  DECLARE @SegLen2 tinyint
  DECLARE @SegLen3 tinyint
  DECLARE @SegLen4 tinyint
  DECLARE @SegLen5 tinyint
  DECLARE @SegLen6 tinyint
  DECLARE @SegLen7 tinyint
  DECLARE @SegLen8 tinyint
  DECLARE @SegLen9 tinyint
  DECLARE @SubLen tinyint
  DECLARE @AcctCode char(64)
  DECLARE @AcctStatus int
  DECLARE @AcctDesc varchar(60)
  DECLARE @NormalBal tinyint
  DECLARE @AcctGroup smallint

  DECLARE @SQLString nvarchar(500)
  DECLARE @DummyEntityNum smallint
  DECLARE @fNoAcctInfo bit
  SET NOCOUNT ON
  /* Get Entity Number from frl_entity */
  select @EntityNum = entity_num 
    from frl_entity 
   where cpnyid = @CpnyID
  if @@ROWCOUNT > 0
   BEGIN
    /* Get Natural Segment Length */
    select @NatSegLen = nat_seg_len
     from frl_glx_ctrl
    /* Get Maximum Segments, individual segment lengths, Sub length */
    SELECT @MaxSegs = NumberSegments + 1, 
           @SegLen2 = SegLength00, 
           @SegLen3 = SegLength01, 
           @SegLen4 = SegLength02, 
           @SegLen5 = SegLength03, 
           @SegLen6 = SegLength04, 
           @SegLen7 = SegLength05, 
           @SegLen8 = SegLength06, 
           @SegLen9 = SegLength07,
           @SubLen = SegLength00 + SegLength01 + SegLength02 + SegLength03 + 
                     SegLength04 + SegLength05 + SegLength06 + SegLength07 
      FROM FlexDef 
     WHERE FieldClassName = 'SUBACCOUNT'
    /* Build acct_code */
    SELECT @AcctCode = substring(@Acct, 1, @NatSegLen) + substring(@Sub, 1, @SubLen)
    SET @fNoAcctInfo = 0
    /* Get status, description, normal balance, and account group */
     IF (select ValidateAcctSub from GLSetup WITH (nolock)) = 1
     and  Exists (select 1 from frl_acctsub_view where acct = @Acct
           AND sub = @Sub
           AND cpnyid = @CpnyID)
      begin
        SELECT @AcctStatus = 
          CASE
            WHEN active = 1 THEN 0 
            WHEN active = 0 THEN 1 
          END, 
          @AcctDesc = descr 
          FROM frl_acctsub_view
         WHERE acct = @Acct
           AND sub = @Sub
           AND cpnyid = @CpnyID 
        IF @@ROWCOUNT = 0
         BEGIN
            SET @fNoAcctInfo = 1
         END
		IF @fNoAcctInfo = 0 
		BEGIN
	        select @NormalBal = 
	          case
	            when substring(accttype, 2, 1) = 'A' THEN 1
	            when substring(accttype, 2, 1) = 'E' THEN 1
	            when substring(accttype, 2, 1) = 'L' THEN 2
	            when substring(accttype, 2, 1) = 'I' THEN 2
	          end,
	          @AcctGroup =
	          case
	            when substring(accttype, 2, 1) = 'A' THEN 1
	            when substring(accttype, 2, 1) = 'L' THEN 2
	            when substring(accttype, 2, 1) = 'E' THEN 3
	            when substring(accttype, 2, 1) = 'I' THEN 4
	          end
	          from account
	         where acct = @Acct
	        IF @@ROWCOUNT = 0
	         BEGIN
			  SET @fNoAcctInfo = 1
	          /* Set some defaults */
	          SET @NormalBal = 1
	          SET @AcctGroup = 1
	         END
		end 
      end
    else
begin
        select @AcctStatus = 
          CASE
            WHEN active = 1 THEN 0
            WHEN active = 0 THEN 1
          END, 
          @AcctDesc = descr,
          @NormalBal = 
          CASE
            WHEN substring(accttype, 2, 1) = 'A' THEN 1
            WHEN substring(accttype, 2, 1) = 'E' THEN 1
            WHEN substring(accttype, 2, 1) = 'L' THEN 2
            WHEN substring(accttype, 2, 1) = 'I' THEN 2
          END,
         @AcctGroup =
          CASE
            WHEN substring(accttype, 2, 1) = 'A' THEN 1
            WHEN substring(accttype, 2, 1) = 'L' THEN 2
            WHEN substring(accttype, 2, 1) = 'E' THEN 3
            WHEN substring(accttype, 2, 1) = 'I' THEN 4
          END
          from account
         where acct = @Acct
        IF @@ROWCOUNT = 0
          SET @fNoAcctInfo = 1
      end
	  IF @fNoAcctInfo = 0
		if len(rtrim(@Sub))>@SubLen 
				begin
				SET @fNoAcctInfo = 1
				Print 'A Sub account was found that is longer than the expected lenght. Sub account: ' + @Sub  + 'will not be added to the FRL_ACCT_CODE table.'
		end
	
    IF @fNoAcctInfo = 0
     BEGIN
           /* Check if exists, prior to insert. */
	      SELECT @DummyEntityNum = entity_num
	        FROM frl_acct_code
	       WHERE cpnyid = @CpnyID
	         AND acct = @Acct
	         AND sub = substring(@Sub, 1, @SubLen)
      IF @@ROWCOUNT = 0
        /* Build select statement */
        insert into frl_acct_code (entity_num,  acct_code, nat_seg_code, 
                            cpnyid, acct, sub, seg01_code, seg02_code, seg03_code,
               	           seg04_code, seg05_code, seg06_code, seg07_code,
                           seg08_code, seg09_code, acct_status, acct_desc,
                           normal_bal, acct_group)
        values (-255,  @AcctCode, substring(@Acct, 1, @NatSegLen),
               @CpnyID, substring(@Acct, 1, @NatSegLen), substring(@Sub, 1, @SubLen),
               substring(@Acct, 1, @NatSegLen),
               substring(@Sub, 1, @SegLen2),
               substring(@Sub, 1 + @SegLen2, @SegLen3),
               substring(@Sub, 1 + @SegLen2 + @SegLen3, @SegLen4),
               substring(@Sub, 1 + @SegLen2 + @SegLen3 + @SegLen4, @SegLen5),
               substring(@Sub, 1 + @SegLen2 + @SegLen3 + @SegLen4 + @SegLen5, @SegLen6),
               substring(@Sub, 1 + @SegLen2 + @SegLen3 + @SegLen4 + @SegLen5 + @SegLen6, @SegLen7),
               substring(@Sub, 1 + @SegLen2 + @SegLen3 + @SegLen4 + @SegLen5 + @SegLen6 + @SegLen7, @SegLen8),
               substring(@Sub, 1 + @SegLen2 + @SegLen3 + @SegLen4 + @SegLen5 + @SegLen6 + @SegLen7 + @SegLen8, @SegLen9),
               @AcctStatus, @AcctDesc, @NormalBal, @AcctGroup)
     END
    ELSE
     BEGIN
      /* Insert records into frl_glx_errs */
      insert into frl_glx_errs (cpnyid, acct, sub, err_date)
        values (@CpnyID, @Acct, @Sub, GetDate() )
     END
 update frl_acct_code 
	set entity_num =
			isnull(( select  entity_num from frl_entity  where frl_entity.cpnyid = frl_acct_code.CpnyID),-1) 
  where entity_num = -255
     
   END
  SET NOCOUNT OFF
GO
