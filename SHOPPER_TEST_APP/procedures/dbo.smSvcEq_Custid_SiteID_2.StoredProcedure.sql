USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smSvcEq_Custid_SiteID_2]    Script Date: 12/21/2015 16:07:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smSvcEq_Custid_SiteID_2] @parm1 varchar(15),@parm2 varchar (10),@parm3 varchar(10)
AS
        SELECT * FROM smSvcEquipment
         WHERE Status = 'A'
           AND CustId LIKE @parm1
           AND SiteID LIKE @parm2
           AND EquipID LIKE @parm3
      ORDER BY EquipID
GO
