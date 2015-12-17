USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XFQ_PublicTemplate_All]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[XFQ_PublicTemplate_All]
@parm1 varchar(20),
@parm2 varchar(20)
AS
Select * from XFQ_Query Where QueryId like @parm1 and UserType = 'S' and VersionId like @parm2 and VersionId <> '(master)'
Order by QueryId, VersionId
GO
