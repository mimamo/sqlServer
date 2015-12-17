USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJCode_Descr]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJCode_Descr]
	@Code_Type	varchar( 4 ),
   	@Code_Value	varchar( 30 )

AS

	SELECT 		code_value_desc
 	FROM 		PJCode
 	WHERE 		Code_Type = @Code_Type
   			and Code_Value = @Code_Value
GO
