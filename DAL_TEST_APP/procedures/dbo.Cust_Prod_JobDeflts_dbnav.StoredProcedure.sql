USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Cust_Prod_JobDeflts_dbnav]    Script Date: 12/21/2015 13:56:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Cust_Prod_JobDeflts_dbnav] 
	@parm1 Varchar (15),
	@parm2 Varchar (30),
	@parm3 Varchar (10)
 
AS


	SELECT xProdJobDefault.*,a.*,b.*,c.status FROM xProdJobDefault,PJEmploy a,PJEmploy b,xIGProdCode c WHERE
 		xProdJobDefault.CustID = @parm1 and
		xProdJobDefault.code_group = @parm2 and
		xProdJobDefault.Product Like @parm3 and
		xProdJobDefault.biller *= a.employee and
		xProdJobDefault.approver *= b.employee and
		xProdJobDefault.Code_group = c.Code_group and
		xProdJobDefault.Product = c.Code_ID
		order by xProdJobDefault.CustID, xProdJobDefault.Product
GO
