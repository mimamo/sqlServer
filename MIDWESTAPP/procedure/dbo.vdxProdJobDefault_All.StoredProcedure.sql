USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[vdxProdJobDefault_All]    Script Date: 12/21/2015 15:55:46 ******/
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
