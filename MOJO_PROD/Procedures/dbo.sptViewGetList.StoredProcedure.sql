USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptViewGetList]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptViewGetList]

AS

Select * from tView (NOLOCK) Order By ViewKey
GO
