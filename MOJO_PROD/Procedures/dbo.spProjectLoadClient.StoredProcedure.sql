USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectLoadClient]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProjectLoadClient]
	(
	@ProjectKey int
	)
AS

select c.* from tProject p (nolock) 
	inner join tCompany c (nolock) on p.ClientKey = c.CompanyKey
Where ProjectKey = @ProjectKey
GO
