USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[xClientContact_pv]    Script Date: 12/21/2015 16:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xClientContact_pv](
@parm1 char(30)
)

AS


SELECT EA_ID, CName, EmailAddress, Company FROM xClientContact WHERE EA_ID like LTRIM(RTRIM(@parm1)) and Status = 'A' ORDER BY EA_ID
GO
