USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_tObjectFieldSetGet]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[spCF_tObjectFieldSetGet]

	(
		@ObjectFieldSetKey int
	)

AS --Encrypt

	Select * 
	From tObjectFieldSet o (nolock)
	Where o.ObjectFieldSetKey = @ObjectFieldSetKey
GO
