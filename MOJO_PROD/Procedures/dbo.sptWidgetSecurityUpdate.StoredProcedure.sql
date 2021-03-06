USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWidgetSecurityUpdate]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptWidgetSecurityUpdate]
(
	@WidgetKey			INT,
	@SecurityGroupKey	INT,
	@CanView			INT,
	@CanEdit			INT
)

AS

	IF EXISTS (SELECT * FROM tWidgetSecurity WHERE WidgetKey = @WidgetKey AND SecurityGroupKey = @SecurityGroupKey) 
		UPDATE	tWidgetSecurity
		SET		CanEdit = @CanEdit, CanView = @CanView
		WHERE	WidgetKey = @WidgetKey 
				AND SecurityGroupKey = @SecurityGroupKey
	ELSE 
		--IF (@CanView = 1 OR @CanEdit = 1) 
		INSERT INTO tWidgetSecurity (WidgetKey, SecurityGroupKey, CanView, CanEdit)
		VALUES (@WidgetKey, @SecurityGroupKey, @CanView, @CanEdit)
GO
