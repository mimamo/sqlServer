USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xiwNEI_ValidateTask]    Script Date: 12/21/2015 13:45:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xiwNEI_ValidateTask]
@TwoStringList ListOfTwoStrings READONLY
AS
SELECT U.Id0, U.Id1
FROM @TwoStringList U
LEFT JOIN PJPENT P
  ON U.Id0 = P.project
 AND U.Id1 = P.pjt_entity
WHERE P.pjt_entity IS NULL
GO
