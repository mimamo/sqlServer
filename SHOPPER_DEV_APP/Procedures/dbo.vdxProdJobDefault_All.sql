USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[vdxProdJobDefault_All]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[vdxProdJobDefault_All]
@parm1 varchar(15)
AS
Select Customer.* 
from vdxProdJobDefault inner join Customer on vdxProdJobDefault.CustId = Customer.CustId 
where vdxProdJobDefault.CustId LIKE @parm1
Order by vdxProdJobDefault.CustId
GO
