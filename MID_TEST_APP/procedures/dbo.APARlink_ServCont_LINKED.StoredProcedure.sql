USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APARlink_ServCont_LINKED]    Script Date: 12/21/2015 15:49:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APARlink_ServCont_LINKED    Script Date: 06/7/06 ******/
Create Procedure [dbo].[APARlink_ServCont_LINKED] @VendID varchar(15), @APRefNbr varchar (10),
                                 @Custid varchar(15), @ARRefNbr varchar (10) AS

SELECT *
  FROM APARLINK
 WHERE Vendid = @VendID
   AND APRefNbr = @APRefNbr
   AND APDoctype = 'VO'
   AND Custid = @Custid
   AND ARRefNbr = @ARRefNbr
   AND ARDoctype = 'IN'
GO
