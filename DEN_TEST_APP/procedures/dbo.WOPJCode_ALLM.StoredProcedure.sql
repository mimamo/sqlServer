USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJCode_ALLM]    Script Date: 12/21/2015 15:37:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJCode_ALLM]
   @Code_Value      varchar(30)

AS
   SELECT           *
   FROM             PJCODE
   WHERE            Code_Type = 'ALLM' and
                    Code_Value LIKE @Code_Value
   ORDER BY         Code_type, Code_value
GO
