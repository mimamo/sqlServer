USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRootFolderInsert]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRootFolderInsert]
 @Name varchar(255),
 @FullPath varchar(255),
 @ParentFolderKey uniqueidentifier,
 @RootFolderKey uniqueidentifier,
 @HasChildren tinyint,
 @CompanyKey int,
 @oIdentity uniqueidentifier OUTPUT
AS --Encrypt
declare @NewFolderRightKey uniqueidentifier
 select @oIdentity = newid()
 select @NewFolderRightKey = newid()
 INSERT tFolder
  (
  FolderKey,
  Name,
  FullPath,
  ParentFolderKey,
  RootFolderKey,
  HasChildren,
  RevisionTracking,
  NbrRevisionsKept,
  LastPubAvailCheckout
  )
 VALUES
  (
  @oIdentity,
  @Name,
  @FullPath,
  @ParentFolderKey,
  @RootFolderKey,
  @HasChildren,
  1,  --none
  -1, --all
  1   --last published accessible during checkout
  )
 
 insert tFolderRight
       (FolderRightKey
       ,FolderKey
       ,EntityType
       ,EntityKey
       ,FolderView
    ,FolderSubscribe
    ,FolderAdd
    ,FolderRename
    ,FolderMove
          ,FolderDelete
          ,FolderOptions
          ,FolderRights
          ,FolderFileAdd
          ,FileView
          ,FileViewRevisions
          ,FileDownload
          ,FileUpdate
          ,FileRename
          ,FileMove
          ,FileDelete
          ,FileRights
       )
 select @NewFolderRightKey
       ,@oIdentity
    ,'Group'
       ,SecurityGroupKey
       ,1
       ,1
       ,1
       ,1
       ,1
       ,1
       ,1
       ,1
       ,1
       ,1
       ,1
       ,1
       ,1
       ,1
       ,1
       ,1
       ,1
   from tSecurityGroup (nolock)
  where Active = 1
    and CompanyKey = @CompanyKey
  
 RETURN 1
GO
