USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDDecimalPlaces]    Script Date: 12/21/2015 15:42:52 ******/
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
