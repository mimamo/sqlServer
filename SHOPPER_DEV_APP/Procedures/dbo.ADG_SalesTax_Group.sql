USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SalesTax_Group]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_SalesTax_Group]
	@GroupId	varchar(10)
as
	-- select the sales tax records that are part of the group id
	select	SalesTax.*
	from	SalesTax
	join	SlsTaxGrp on SlsTaxGrp.TaxId = SalesTax.TaxId
	where	SlsTaxGrp.GroupId = @GroupId
	  and	SalesTax.TaxType = 'T'

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
