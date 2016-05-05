USE [MOJo_dev]
GO
/****** Object:  StoredProcedure [dbo].[spCF_tFieldSetInsert]    Script Date: 04/29/2016 15:04:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'spCF_UpdateFieldValue'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[spCF_tFieldSetInsert]
GO

CREATE PROCEDURE [dbo].[spCF_tFieldSetInsert] 
 @OwnerEntityKey int,
 @AssociatedEntity varchar(50),
 @FieldSetName varchar(75),
 @Active tinyint = 1,
 @UserKey int = null,
 @oIdentity INT OUTPUT
AS --Encrypt

/*******************************************************************************************************
*   MOJo_dev.dbo.spCF_tFieldSetInsert
*
*   Creator:	WMJ   
*   Date:		     
*   
*          
*   Notes: 
*
*   Usage:	set statistics io on

	-- to add a new field set (project, company, etc)
	execute MOJo_dev.dbo.spCF_tFieldSetInsert @OwnerEntityKey = 1, @AssociatedEntity = 'Project', @FieldSetName = 'Project'
		
	

*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/

INSERT mojo_dev.dbo.tFieldSet
(
  OwnerEntityKey,
  AssociatedEntity,
  FieldSetName,
  Active,
  CreatedByKey,
  CreatedByDate,
  UpdatedByKey,
  DateUpdated
)
select @OwnerEntityKey,
  @AssociatedEntity,
  @FieldSetName,
  @Active,
  @UserKey,
  GETUTCDATE(),
  @UserKey,
  GETUTCDATE()
 
 SELECT @oIdentity = @@IDENTITY
 RETURN 1
 