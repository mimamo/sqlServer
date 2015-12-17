USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDecimalPlaces]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDDecimalPlaces] As
Declare @DecPlPrcCst smallint
Declare @DecPlQty smallint
Select @DecPlPrcCst = DecPlPrcCst From EDSetup
Select @DecPlQty = DecPlQty From INSetup
Select @DecPlPrcCst, @DecPlQty
GO
