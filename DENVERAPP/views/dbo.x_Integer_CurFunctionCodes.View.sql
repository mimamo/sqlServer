USE [DENVERAPP]
GO
/****** Object:  View [dbo].[x_Integer_CurFunctionCodes]    Script Date: 12/21/2015 15:42:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[x_Integer_CurFunctionCodes]
as

SELECT DISTINCT project,pjt_entity
FROM PJREVTSK
GO
