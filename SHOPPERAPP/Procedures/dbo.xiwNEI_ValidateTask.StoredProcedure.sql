USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xiwNEI_ValidateTask]    Script Date: 12/21/2015 16:13:29 ******/
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
 AND status_pa = 'A' 
 AND status_ap = 'A'
WHERE P.pjt_entity IS NULL
GO
