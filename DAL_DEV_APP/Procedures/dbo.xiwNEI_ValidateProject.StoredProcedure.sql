USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xiwNEI_ValidateProject]    Script Date: 12/21/2015 13:36:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xiwNEI_ValidateProject]
@StringList ListOfString READONLY
AS
SELECT U.Id
FROM @StringList U
LEFT JOIN PJProj P
  ON U.Id = P.project
WHERE P.project IS NULL
GO
