USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetSubscribers]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[sptActivityGetSubscribers]
(
	@ProjectKey int,
	@Type varchar(20)
)

as

if @Type = 'diary'
	SELECT	v.UserKey,
			v.UserName,
			ISNULL(asn.SubscribeDiary, 0) as SubscribeD,
			ISNULL(asn.SubscribeToDo, 0) as SubscribeT,
			ISNULL(ClientVendorLogin, 0) AS ClientVendorLogin
	FROM	vUserName v (nolock) 
	INNER JOIN tAssignment asn (nolock) ON v.UserKey = asn.UserKey
	Where asn.ProjectKey = @ProjectKey and asn.SubscribeDiary = 1 
	Order By UserName
	

if @Type = 'todo'
	SELECT	v.UserKey,
			v.UserName,
			ISNULL(ClientVendorLogin, 0) AS ClientVendorLogin
	FROM	vUserName v (nolock) 
	INNER JOIN tAssignment asn (nolock) ON v.UserKey = asn.UserKey
	Where asn.ProjectKey = @ProjectKey and asn.SubscribeToDo = 1 
	Order By UserName
GO
