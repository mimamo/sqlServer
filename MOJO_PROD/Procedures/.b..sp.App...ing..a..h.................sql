USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAppStringSearch]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptAppStringSearch]
(
	@Value varchar(max)
)

as 

Select top 300 StringKey as k, EN as n from tAppString (nolock) Where EN like '%' + @Value + '%'
GO
