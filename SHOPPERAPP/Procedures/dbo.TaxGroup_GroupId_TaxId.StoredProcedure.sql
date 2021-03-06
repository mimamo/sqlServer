USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[TaxGroup_GroupId_TaxId]    Script Date: 12/21/2015 16:13:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[TaxGroup_GroupId_TaxId] @parm1 varchar ( 10), @parm2 varchar ( 10) as
Select *
from SlsTaxGrp
	left outer join SalesTax
		on SlsTaxGrp.TaxId = SalesTax.TaxId
where SlsTaxGrp.GroupId = @parm1
	and SlsTaxGrp.TaxId LIKE @parm2
	and SalesTax.TaxType = 'T'
order by SlsTaxGrp.GroupId,
	SlsTaxGrp.TaxId
GO
