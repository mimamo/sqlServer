USE [DAL_DEV_APP]
GO
/****** Object:  View [dbo].[x_Integer_CurFunctionCodes]    Script Date: 12/21/2015 13:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[x_Integer_CurFunctionCodes]
as

SELECT DISTINCT project,pjt_entity
FROM PJREVTSK
GO
