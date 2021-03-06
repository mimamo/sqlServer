USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spPostRevisionRelease]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spPostRevisionRelease]
 @TransmittalKey int
 
AS --Encrypt
 DECLARE @ReleaseDate smalldatetime,
   @ReleasePointKey int
 SELECT  RevisionKey INTO #tTransmitRevision
 FROM tTransmitRevision (nolock)
 WHERE TransmittalKey = @TransmittalKey
 
 SELECT @ReleaseDate = DateSent, @ReleasePointKey = ReleasePointKey
 FROM tTransmittal (nolock)
 WHERE TransmittalKey = @TransmittalKey
 
 UPDATE tRevisionRelease
 SET  ReleaseDate = @ReleaseDate
 WHERE RevisionKey IN
    (SELECT RevisionKey
    FROM #tTransmitRevision)
 AND  ReleasePointKey = @ReleasePointKey
 
 INSERT tRevisionRelease
    (RevisionKey,
    ReleasePointKey,
    ReleaseDate)
     SELECT RevisionKey,
       @ReleasePointKey,
       @ReleaseDate
     FROM #tTransmitRevision
     WHERE RevisionKey NOT IN
        (SELECT RevisionKey
        FROM tRevisionRelease (nolock)
        WHERE ReleasePointKey = @ReleasePointKey)
        
 DROP TABLE #tTransmitRevision
 
 RETURN 1
GO
