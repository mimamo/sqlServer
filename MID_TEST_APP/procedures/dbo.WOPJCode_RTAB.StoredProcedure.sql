USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJCode_RTAB]    Script Date: 12/21/2015 15:49:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJCode_RTAB]
   @Code_Value      varchar(30)

AS
   SELECT           *
   FROM             PJCODE
   WHERE            Code_Type = 'RTAB' and
                    Code_Value LIKE @Code_Value
   ORDER BY         Code_type, Code_value
GO
