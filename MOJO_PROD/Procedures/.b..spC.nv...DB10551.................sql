USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10551]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10551]


AS

Insert tLabCompany (LabKey, CompanyKey)
Select 34, CompanyKey 
	From tLabCompany (nolock) Where LabKey = 24

delete tLayoutBilling
where  tLayoutBilling.Entity = 'tService'
and    not exists (select 1 from tService s (nolock) where s.ServiceKey = tLayoutBilling.EntityKey)


delete tLayoutBilling
where  tLayoutBilling.Entity = 'tItem'
and    not exists (select 1 from tItem i (nolock) where i.ItemKey = tLayoutBilling.EntityKey)
GO
