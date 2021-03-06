USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10588]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10588]

AS
	SET NOCOUNT ON

	-- must seed new Recalc Labor Right for Abelson Taylor
	if not exists (select 1 from tRightAssigned (nolock) where RightKey = 90337) -- only do it once
	insert tRightAssigned (EntityType, EntityKey, RightKey)
	select 'Security Group', SecurityGroupKey, 90337
	from tSecurityGroup (nolock)
GO
