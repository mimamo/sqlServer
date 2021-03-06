USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[vs_1099Info]    Script Date: 12/21/2015 14:05:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_1099Info] AS 

SELECT v.RI_ID, 
       v.cMasterFedID,
       v.VendID,
       v.cpnyId,
       c.cpnyName,
       c.addr1 caddr1,
       c.addr2 caddr2,
       c.city ccity,
       c.phone cphone,
       c.state cstate,
       c.zip czip,
       v.VendorName,  
       v.Addr1, 
       v.Addr2, 
       v.City, 
       v.State, 
       v.Zip,
       v.Vend1099, 
       v.ConTwc1099,
       v.TIN,
       v.CYBox00, 
       v.CYBox01, 
       v.CYBox02, 
       v.CYBox03, 
       v.CYBox04, 
       v.CYBox05,  
       v.CYBox06, 
       v.CYBox07, 
       v.CYBox08,
       v.CYBox09,      
       v.CYBox10, 
       v.CYBox15a,
       v.CYBox15b,     
    
       v.CYBox13,      
       v.CYBox14,

       v.NYBox00, 
       v.NYBox01, 
       v.NYBox02, 
       v.NYBox03, 
       v.NYBox04,  
       v.NYBox05, 
       v.NYBox06, 
       v.NYBox07, 
       v.NYBox08,
       v.NYBox09,      
       v.NYBox10,
       v.NYBox15a,
       v.NYBox15b,      

       v.NYBox13,      
       v.NYBox14,
       v.VendorUser1, v.VendorUser2, v.VendorUser3, v.VendorUser4,
       v.VendorUser5, v.VendorUser6, v.VendorUser7, v.VendorUser8

FROM vp_1099Info_Prep v INNER JOIN vs_Company c ON v.cpnyid = c.cpnyid
GO
