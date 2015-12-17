USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AP_Pay_Select]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[AP_Pay_Select] @UserID varchar(10), @AccessNbr smallint,  @ChkPrtDate smalldatetime, @TranCuryId varchar(4), @RateType varchar(6), @EffDate smalldatetime, @Rate float, @MultDiv varchar(1), @CuryDecPl int, @BatNbr varchar(10), @CpnyID varchar(10), @Preview smallint AS
set nocount on
DECLARE @APResult INT

exec APCheckSel_SetSelected @UserID, @AccessNbr, @Preview, @APResult OUTPUT
if @APResult = 0 RETURN

exec APCheckSel_Calc_Payment @AccessNbr, @ChkPrtDate, @TranCuryId, @MultDiv,  @Rate, @CuryDecPl, @EffDate, @RateType, @Preview, @APResult OUTPUT
if @APResult = 0 RETURN

exec APCheck_Create_Trans @AccessNbr, @ChkPrtDate, @TranCuryId, @RateType ,@EffDate,
@Rate, @MultDiv, @BatNbr, @Cpnyid, @Preview, @APResult OUTPUT
if @APResult = 0 RETURN

exec APCheck_Update_Docs @AccessNbr, @BatNbr, @Preview, @APResult OUTPUT
if @APResult = 0 RETURN
GO
