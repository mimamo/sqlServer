USE [SHOPPER_TEST_APP]
GO
/****** Object:  View [dbo].[vp_03400_UpdateRcpt]    Script Date: 12/21/2015 16:06:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_03400_UpdateRcpt] AS 

Select  a.useraddress,a.rcptnbr, a.ExtRefNbr,
        VouchStage = (select Max(VouchStage) 
                          FROM potran t
                         WHERE  a.rcptnbr = t.rcptnbr )


  From vp_03400_aptran_rcptnbr a
 WHERE EXISTS(select * 
                          FROM potran t
                         WHERE  a.rcptnbr = t.rcptnbr )
GO
