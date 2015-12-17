USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xIGProdCode_ProdGrp_pv]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 10/13/2009 JWG & MSB

CREATE PROCEDURE [dbo].[xIGProdCode_ProdGrp_pv]( 
@parm1 Varchar (30)
)
 
AS


SELECT DISTINCT code_group FROM xIGProdCode WHERE code_group like @parm1 ORDER BY code_group
GO
