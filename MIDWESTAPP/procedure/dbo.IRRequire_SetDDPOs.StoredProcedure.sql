USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[IRRequire_SetDDPOs]    Script Date: 12/21/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[IRRequire_SetDDPOs] @InvtId VarChar(30), @MaxDate SmallDateTime, @SiteID VarChar(10) AS
	Update IRRequirement set DueDatePlan = @MaxDate where InvtId = @InvtId and SiteID Like @SiteID and DocumentType in ('PO','PL')
GO
