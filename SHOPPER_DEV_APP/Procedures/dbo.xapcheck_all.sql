USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xapcheck_all]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[xapcheck_all] @BatNbr varchar(10) AS
Select * from XAPCheck where BatNbr like @BatNbr and Printed = 1 order by BatNbr
GO
