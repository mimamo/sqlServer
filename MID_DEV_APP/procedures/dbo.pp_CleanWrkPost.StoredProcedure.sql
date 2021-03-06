USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pp_CleanWrkPost]    Script Date: 12/21/2015 14:17:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[pp_CleanWrkPost] @UserAddress char(21)
WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as

/* Delete all batches for my user */
DELETE WrkPost where UserAddress = @UserAddress

/* Delete batches if we cannot find an access record for the correct
   InternetAddress(Useraddress).  Since the access table in the system
   Database can point to multiple app databases, also make check the database
   name to make sure were only deleting records for the app db we are currently in.) */

DELETE w
  FROM Wrkpost w
 WHERE NOT EXISTS
     (SELECT 'Orphaned WrkPost Records'
        FROM vs_Access va
       WHERE w.useraddress = va.InterNetAddress AND
             va.ScrnNbr IN('01520','0152000') AND
             va.DatabaseName = DB_NAME())
GO
