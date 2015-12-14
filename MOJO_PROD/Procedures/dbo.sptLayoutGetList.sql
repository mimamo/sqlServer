USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLayoutGetList]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLayoutGetList]
	(
	@CompanyKey int,
	@Entity varchar(50)
	)

AS


Select * from tLayout (nolock) 
Where CompanyKey = @CompanyKey and Entity = @Entity
Order By LayoutName
GO
