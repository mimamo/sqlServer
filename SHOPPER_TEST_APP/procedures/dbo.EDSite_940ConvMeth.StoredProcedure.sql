USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSite_940ConvMeth]    Script Date: 12/21/2015 16:07:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSite_940ConvMeth] @SiteId varchar(10) As
Select ConvMeth From EDSite Where SiteId = @SiteId And Trans = '940'
GO
