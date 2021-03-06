USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[frx_initial_glx_build]    Script Date: 12/21/2015 15:36:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[frx_initial_glx_build]
	@NaturalLength tinyint,
	@SpecificCpnyID char(10) = 'ALL'
AS
  DECLARE @fErrFound bit
  DECLARE @SQLString nvarchar(500)
  DECLARE @EntityNum smallint
  DECLARE @MaxEntityNum smallint
  DECLARE @CpnyID char(10)
  DECLARE @Acct char(10)
  DECLARE @Sub char(24)
  DECLARE @fSpecificCpny bit  
  SET NOCOUNT ON
  SET @fErrFound = 0
  /* Check the natural length parameter. */
  IF @NaturalLength < 1 or @NaturalLength > 10
    BEGIN
PRINT 'Natural Segment Length must be between 1 and 10.'
      select @fErrFound = 1
    END
  IF @fErrFound = 0
    BEGIN
      /* Check for Specific Company building. */
     IF @SpecificCpnyID = 'ALL'
        SET @fSpecificCpny = 0
     ELSE
        SET @fSpecificCpny = 1
           /* Insert frl_glx_ctrl record */
      select * from frl_glx_ctrl
      IF @@ROWCOUNT > 0
        update frl_glx_ctrl
           set nat_seg_len = @NaturalLength
      ELSE
        insert into frl_glx_ctrl
          (nat_seg_len) values (@NaturalLength)
      /* Insert frl_entity records */
	IF @fSpecificCpny = 0      
       BEGIN
        select * from frl_entity
        IF @@ROWCOUNT > 0
          delete frl_entity
        SET @SQLString = 'insert into frl_entity (entity_num, cpnyid) ' +
                          'select 0, cpnyid from vs_Company where databasename = db_name()'
        EXEC sp_executesql @SQLString
        SET @EntityNum = 0
        DECLARE Entity_Cursor CURSOR FAST_FORWARD FOR
          select cpnyid from frl_entity
        OPEN Entity_Cursor 
        FETCH NEXT FROM Entity_Cursor into @CpnyID
        WHILE @@FETCH_STATUS = 0
          BEGIN
            SELECT @EntityNum = @EntityNum + 1
            UPDATE frl_entity
              SET entity_num = @EntityNum
              WHERE cpnyid = @CpnyID
            FETCH NEXT FROM Entity_Cursor into @CpnyID
          END
        CLOSE Entity_Cursor 
        DEALLOCATE Entity_Cursor 
        /* Delete all frl_acct_code records. */
        DELETE frl_acct_code
      END
      ELSE
       BEGIN
        /* Check if exist */
        SELECT @EntityNum = entity_num
          FROM frl_entity
         WHERE cpnyid = @SpecificCpnyID
        IF @@ROWCOUNT = 0
         BEGIN
          /* Add frl_entity record. */
          SELECT @MaxEntityNum = max(entity_num)
            FROM frl_entity
          IF @MaxEntityNum is NULL
            SET @MaxEntityNum = 0
          insert into frl_entity (entity_num, cpnyid)
            values (@MaxEntityNum + 1, @SpecificCpnyID)
         END
        ELSE
          /* Delete frl_acct_code records for company. */
          DELETE frl_acct_code
           WHERE cpnyid = @SpecificCpnyID
       END
      /* Fill frl_acct_code from AcctHist table. */
      if @fSpecificCpny = 0
        DECLARE AcctHist_Cursor CURSOR FAST_FORWARD FOR
          select distinct cpnyid, acct, sub
            from accthist
      ELSE
        DECLARE AcctHist_Cursor CURSOR FAST_FORWARD FOR
          select distinct cpnyid, acct, sub
            from accthist
           WHERE cpnyid = @SpecificCpnyID
      OPEN AcctHist_Cursor
      FETCH NEXT FROM AcctHist_Cursor into @CpnyID, @Acct, @Sub
      WHILE @@FETCH_STATUS = 0
        BEGIN
          EXEC frx_insert_acct_code @CpnyID, @Acct, @Sub
          FETCH NEXT FROM AcctHist_Cursor into @CpnyID, @Acct, @Sub
        END
      CLOSE AcctHist_Cursor 
      DEALLOCATE AcctHist_Cursor 
      /* Fill frl_acct_code from GLTran table unposted and released transactions. */
      if @fSpecificCpny = 0
        DECLARE GLTran_Cursor CURSOR FAST_FORWARD FOR
          select distinct cpnyid, acct, sub
            from gltran
           where posted = 'U'
             and rlsed = 1
      ELSE
        DECLARE GLTran_Cursor CURSOR FAST_FORWARD FOR
          select distinct cpnyid, acct, sub
            from gltran
           where posted = 'U'
             and rlsed = 1
             and cpnyid = @SpecificCpnyID
      OPEN GLTran_Cursor 
      FETCH NEXT FROM GLTran_Cursor into @CpnyID, @Acct, @Sub
      WHILE @@FETCH_STATUS = 0
        BEGIN
          /* Check if frl_acct_code record exists. */
          SELECT @EntityNum = entity_num
            FROM frl_acct_code
           WHERE cpnyid = @CpnyID
             AND acct = @Acct
             AND sub = @Sub
          IF @@ROWCOUNT = 0
            EXEC frx_insert_acct_code @CpnyID, @Acct, @Sub
            SET NOCOUNT ON
        FETCH NEXT FROM GLTran_Cursor into @CpnyID, @Acct, @Sub
        END
      CLOSE GLTran_Cursor 
      DEALLOCATE GLTran_Cursor 
  END
  SET NOCOUNT OFF
GO
