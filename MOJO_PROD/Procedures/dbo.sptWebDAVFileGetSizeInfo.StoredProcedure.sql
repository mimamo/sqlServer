USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDAVFileGetSizeInfo]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDAVFileGetSizeInfo]
	@CompanyKey int
AS

/*
|| When      Who Rel      What
|| 1/9/15    KMC 10.5.8.8 Created to get WebDAV file size info from the database instead of from Windows file system
|| 2/27/15   KMC 10.5.8.9 Updated to make sure we are only pulling companies that are hosting with us and not on their own server.
|| 4/14/15   KMC 10.5.9.0 Added ISNULL handling
*/

IF EXISTS(select CompanyKey 
			from tWebDavServer (nolock) 
		   where CompanyKey = @CompanyKey
		     and ISNULL(URL, '') not like '%.workamajig.com/files%')
BEGIN
	SELECT 0 as TotalWebDAVFileSize, GETDATE() as FileSizeDate
END
ELSE
BEGIN
	SELECT ISNULL(CAST(p.ProjectFileSize as bigint), 0) + 
		   ISNULL(CAST(p.ReviewFileSize as bigint), 0) + 
		   ISNULL((select SUM(CAST(a.Size as bigint)) 
			  from tAttachment a (nolock) 
			 where a.CompanyKey = @CompanyKey), 0) as TotalWebDAVFileSize
		 , p.FileSizeDate
	from tPreference p (nolock)
	where p.CompanyKey = @CompanyKey
END
GO
