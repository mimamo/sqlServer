USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDVInbound_810880ConvMeth]    Script Date: 12/21/2015 16:13:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDVInbound_810880ConvMeth] @VendId varchar(15) As
Select ConvMeth From EDVInbound Where VendId = @VendId And Trans In ('810','880')
GO
