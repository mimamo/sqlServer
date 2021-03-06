USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xProdJobDefault_Client_pv]    Script Date: 12/21/2015 13:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xProdJobDefault_Client_pv]( 
@parm1 Varchar (15)
, @parm2 Varchar (10)
)

AS

SELECT xProdJobDefault.Product, xProdJobDefault.code_group FROM xProdJobDefault JOIN xIGProdCode ON xProdJobDefault.Product = xIGProdCode.code_ID WHERE xProdJobDefault.custID = @parm1 AND xProdJobDefault.Product like @parm2 AND xIGProdCode.[status] = 'A' ORDER BY xProdJobDefault.Product
GO
