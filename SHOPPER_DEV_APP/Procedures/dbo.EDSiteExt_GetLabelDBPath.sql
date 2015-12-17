USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSiteExt_GetLabelDBPath]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSiteExt_GetLabelDBPath] @SiteId varchar(10) As
Declare @LabelDBPath varchar(255)
Select @LabelDBPath = LabelDBPath From EDSiteExt Where SiteId = @SiteId
If LTrim(RTrim(@LabelDBPath)) = ''
  Select @LabelDBPath = LabelDBPath From ANSetup
Select @LabelDBPath
GO
