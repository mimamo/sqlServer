USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_LabelPath]    Script Date: 12/21/2015 15:49:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainer_LabelPath] @ContainerId varchar(10) As
Declare @Path varchar(255)
Select @Path = C.LabelDBPath From EDContainer A, SOShipHeader B, EDSiteExt C
Where A.ContainerId = @ContainerId And A.CpnyId = B.CpnyId And A.ShipperId = B.ShipperId And
B.SiteId = C.SiteId
If LTrim(RTrim(@Path)) = ''
  Select @Path = LabelDBPath From ANSetup
Select @Path
GO
