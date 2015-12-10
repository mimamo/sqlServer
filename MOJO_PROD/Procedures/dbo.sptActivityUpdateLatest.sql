USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityUpdateLatest]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityUpdateLatest]
	(
	@Entity varchar(20),
	@EntityKey int,
	@NextKey int,
	@LastKey int
	)

AS


if @Entity = 'tCompany'
	Update tCompany Set NextActivityKey = @NextKey, LastActivityKey = @LastKey Where CompanyKey = @EntityKey
	
if @Entity = 'tUser'
	Update tUser Set NextActivityKey = @NextKey, LastActivityKey = @LastKey Where UserKey = @EntityKey
	
if @Entity = 'tUserLead'
	Update tUserLead Set NextActivityKey = @NextKey, LastActivityKey = @LastKey Where UserLeadKey = @EntityKey
	
if @Entity = 'tLead'
	Update tLead Set NextActivityKey = @NextKey, LastActivityKey = @LastKey Where LeadKey = @EntityKey
GO
