USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDWrkCheckSel_Display]    Script Date: 12/21/2015 13:36:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDWrkCheckSel_Display]
   @AccessNbr		smallint,
   @AscDesc		varchar( 1 )		-- "A"scending order, "D"escending order

AS

	Declare @Acct			varchar( 10 )
	Declare @CpnyID			varchar( 10 )
   	Declare @NeedMultiCury	bit
   	Declare @NeedSettleDate	bit
	Declare @Sub			varchar( 24 )
   
   -- Determine if Settlement Date is an issue
   SET @NeedSettleDate = 0
   if exists(SELECT * FROM XDDWrkCheckSel
   		WHERE	AccessNbr = @AccessNbr
   				and EBGroup <> ''
   				and EBChkWF_CreateMCB = 'S')
		SET @NeedSettleDate = 1

   -- Determine if Multi-Currency Filtering is an issue
   SET @NeedMultiCury = 0
   SELECT TOP 1 	@CpnyID = CpnyID,
   					@Acct = User1,
   					@Sub = User2
   		FROM		XDDWrkCheckSel (nolock)
   		WHERE		AccessNbr = @AccessNbr
   
   SELECT @NeedMultiCury = convert(bit, WTFilterMultiCury) 
   		FROM XDDBank (nolock)
   		Where CpnyID = @CpnyID
   			  and Acct = @Acct
   			  and Sub = @Sub

	-- TempTable
	CREATE TABLE #TempTable
	(	EBBatNbr   		char ( 10 )	NOT NULL,
		EBGroup			char ( 1 )	NOT NULL,
		VendID			char( 15 )	NOT NULL,
		RefNbr			char( 10 ) 	NOT NULL,
		EBDescr			char( 60 )  NOT NULL,
		EBFormatID		char( 15 )	NOT NULL,
		OrigGroup		char( 1 )   NOT NULL,
		EBChkWF			char( 1 )   NOT NULL,
		PayDate			smalldatetime NOT NULL,
		CuryID			char( 4 )	NOT NULL
	)

	INSERT INTO #TempTable
	(EBBatNbr, EBGroup, VendID, RefNbr,
	 EBDescr, EBFormatID, OrigGroup,
	 EBChkWF, PayDate, CuryID)
	SELECT	EBBatNbr, EBGroup, 
			VendID, -- convert(smallint, Count(Distinct VendID)), 
			RefNbr, -- convert(smallint, Count(Distinct RefNbr)), 
			EBDescr,
			EBFormatID,
			' ',
			Case when EBFormatID = '' then 'C'
				else EBChkWF
				end,
			Case when @NeedSettleDate = 1
				then PayDate
				else convert(smalldatetime, 0)
				end,
			case when @NeedMultiCury = 1
		   				then CuryID
		   				else ''
		   				end As 'CuryID'
	FROM	XDDWrkCheckSel (nolock)
	WHERE	AccessNbr = @AccessNbr
   
   	if @AscDesc = 'D'  
		SELECT EBBatNbr, EBGroup, 
				convert(smallint, Count(Distinct VendID)), 
				convert(smallint, Count(Distinct RefNbr)), 
				EBDescr, EBFormatID, OrigGroup,
				EBChkWF, PayDate, CuryID
		FROM	#TempTable
		GROUP BY EBBatNbr, EBGroup, EBDescr, EBFormatID, OrigGroup, EBChkWF, PayDate, CuryID
		ORDER BY EBBatNbr DESC, EBGroup
	else
		SELECT EBBatNbr, EBGroup, 
				convert(smallint, Count(Distinct VendID)), 
				convert(smallint, Count(Distinct RefNbr)), 
				EBDescr, EBFormatID, OrigGroup,
				EBChkWF, PayDate, CuryID
		FROM	#TempTable
		GROUP BY EBBatNbr, EBGroup, EBDescr, EBFormatID, OrigGroup, EBChkWF, PayDate, CuryID
		ORDER BY EBBatNbr, EBGroup
GO
