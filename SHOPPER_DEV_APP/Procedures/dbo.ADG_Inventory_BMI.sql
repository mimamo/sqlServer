USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Inventory_BMI]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Inventory_BMI]
as
	declare @BMIEnabled	smallint
	declare @MCActivated	smallint
	declare	@Enabled	smallint

	select	@MCActivated = MCActivated
	from	CMSetup (nolock)

	select	@BMIEnabled = BMIEnabled
	from	INSetup (nolock)

	select	(coalesce(@MCActivated, 0) & coalesce(@BMIEnabled, 0))
GO
