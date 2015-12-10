USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10544]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10544]

as


Delete tTaskUser Where TaskKey is null and ServiceKey is null


DBCC checkident ('tMobileSearch', reseed, 1000)
delete tMobileSearchCondition
delete tMobileSearch

exec spConvertDBSeed
GO
