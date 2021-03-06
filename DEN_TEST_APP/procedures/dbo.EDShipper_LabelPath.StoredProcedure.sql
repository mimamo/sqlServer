USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipper_LabelPath]    Script Date: 12/21/2015 15:36:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDShipper_LabelPath] @CpnyId varchar(10), @ShipperId varchar(15) As
Declare @Path varchar(255)
Select @Path = B.LabelDBPath From SOShipHeader A, EDSiteExt B Where A.CpnyId = @CpnyId And
A.ShipperId = @ShipperId And A.SiteId = B.SiteId
If LTrim(RTrim(@Path)) = ''
  Select @Path = LabelDBPath From ANSetup
Select @Path
GO
