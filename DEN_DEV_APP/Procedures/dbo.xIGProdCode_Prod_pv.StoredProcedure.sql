USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xIGProdCode_Prod_pv]    Script Date: 12/21/2015 14:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 10/13/2009 JWG & MSB

CREATE PROCEDURE [dbo].[xIGProdCode_Prod_pv](
@parm1 Varchar (30)
, @parm2 Varchar (4)
)
 
AS


SELECT * FROM xIGProdCode WHERE code_group = @parm1 AND code_ID like @parm2 AND [status] = 'A' ORDER BY code_group, code_id
GO
