USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_CU_CustClassSelected]    Script Date: 12/21/2015 15:36:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_CU_CustClassSelected]
	@ClassId	varchar(6),
	@ARAcct      	varchar(10) OUTPUT,
	@ARSub        	varchar(24) OUTPUT,
	@PrcLvlID     	varchar(10) OUTPUT,
	@PrePayAcct   	varchar(10) OUTPUT,
	@PrePaySub    	varchar(24) OUTPUT,
	@PriceClass   	varchar(6) OUTPUT,
	@SlsAcct      	varchar(10) OUTPUT,
	@SlsSub       	varchar(24) OUTPUT,
	@Terms        	varchar(2) OUTPUT,
	@TradeDisc    	decimal(25,9) OUTPUT
as
	select	@ARAcct = ltrim(rtrim(ARAcct)),
		@ARSub = ltrim(rtrim(ARSub)),
		@PrcLvlID = ltrim(rtrim(PrcLvlID)),
		@PrePayAcct = ltrim(rtrim(PrePayAcct)),
		@PrePaySub = ltrim(rtrim(PrePaySub)),
		@PriceClass = ltrim(rtrim(PriceClass)),
		@SlsAcct = ltrim(rtrim(SlsAcct)),
		@SlsSub = ltrim(rtrim(SlsSub)),
		@Terms = ltrim(rtrim(Terms)),
		@TradeDisc = TradeDisc
	from	CustClass (NOLOCK)
	where	ClassId = @ClassId

	if @@ROWCOUNT = 0
		return 0	--Failure
	else
		return 1	--Success
GO
