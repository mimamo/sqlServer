USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWidgetGetUserList]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWidgetGetUserList]
	@CheckTime smalldatetime,
	@UserKey int
AS --Encrypt

/*
|| When      Who Rel     What
|| 02/11/08  CRG 1.0.0.0 Added @CheckTime for the ListManager
*/

Declare @SecurityGroupKey int, @CompanyKey int

Select @SecurityGroupKey = SecurityGroupKey,
	@CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey)
From tUser (nolock)
Where
	UserKey = @UserKey

IF @CheckTime IS NULL
	OR EXISTS --Return the list if the user's record has been modified, since their SecurityGroupKey may have been changed
			(SELECT NULL
			FROM	tUser (nolock)
			WHERE	UserKey = @UserKey
			AND		LastModified > @CheckTime)
	OR EXISTS --Return the list if tWidgetCompany has changed
			(SELECT NULL
			FROM	tWidgetCompany (nolock)
			WHERE	CompanyKey = @CompanyKey
			AND		LastModified > @CheckTime)
	OR EXISTS --Return the list if tWidgetSecurity has changed
			(SELECT NULL
			FROM	tWidgetSecurity (nolock)
			WHERE	SecurityGroupKey = @SecurityGroupKey
			AND		LastModified > @CheckTime)
	Select w.*, wc.Settings as CompanySettings, ISNULL(ws.CanView, 0) as CanView, ISNULL(ws.CanEdit, 0) as CanEdit
	From 
		tWidget w (nolock)
		left outer join (Select * from tWidgetCompany Where CompanyKey = @CompanyKey) as wc on w.WidgetKey = wc.WidgetKey
		left outer join (Select * from tWidgetSecurity Where SecurityGroupKey = @SecurityGroupKey) as ws on w.WidgetKey = ws.WidgetKey
GO
