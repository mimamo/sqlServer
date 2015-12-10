USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRevisionGetDetails]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create  Procedure [dbo].[spRevisionGetDetails]
  @FileRevisionKey uniqueidentifier
As
 select fo.FolderKey
       ,fo.FullPath + '\' + fo.Name as FolderPath
       ,fo.RevisionTracking
       ,fo.LastPubAvailCheckout
       ,fi.FileKey
    ,fi.Name as FileName
    ,fi.LatestFileRevKey
    ,fi.LatestFilePubKey
    ,fi.PublishStatus
    ,fi.Locked
    ,fi.LockedBy
    ,fr.FileRevisionKey
    ,fr.RevisionID 
    ,fr.AddOrder
    ,fr.DateAdded
    ,fr.DateRevised
    ,fr.RevisedBy
    ,fr.FileDeleted
      from tFileRevision fr (nolock)
           ,tFile fi (nolock)
           ,tFolder fo (nolock)
     where fr.FileRevisionKey = @FileRevisionKey
       and fr.FileKey = fi.FileKey
       and fi.FolderKey = fo.FolderKey
    
 return 1
GO
