USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[vp_1099Info_Prep]    Script Date: 12/21/2015 16:12:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_1099Info_Prep] AS 

SELECT vc.RI_ID, 
       vc.Master_Fed_ID cMasterFedID,
       v.VendID VendId, 
       MAX(vc.CpnyId) CpnyId,
       MAX(v.Name) VendorName,  
       MAX(v.Addr1) Addr1, 
       MAX(v.Addr2) Addr2, 
       MAX(v.City) City, 
       MAX(v.State) State, 
       MAX(v.Zip) Zip,
       MAX(v.Vend1099) Vend1099, 
       MAX(v.ContTwc1099) ConTwc1099,
       MAX(v.TIN) TIN,
	---the following are off by one from the actual printed form box number
	---i.e. Box 1 on the form = CYBox00, etc.
       SUM(CYBox00) CYBox00, 
       SUM(CYBox01) CYBox01, 
       SUM(CYBox02) CYBox02, 
       SUM(CYBox03) CYBox03, 
       SUM(CYBox04) CYBox04, 
       SUM(CYBox05) CYBox05,  
       SUM(CYBox06) CYBox06, 
       SUM(CYBox07) CYBox07, 
       SUM(CYBox08) CYBox08,
       SUM(CYBox09) CYBox09,
       SUM(CYBox10) CYBox10,
       SUM(CYBox11) CYBox15a,
       SUM(CYBox12) CYBox15b,

	---the following boxes match those on the form
       SUM(a.S4Future03) CYBox13,
       SUM(a.S4Future04) CYBox14,

	---the following are off by one from the actual printed form box number
	---i.e. Box 1 on the form = NYBox00, etc.
       SUM(NYBox00) NYBox00, 
       SUM(NYBox01) NYBox01, 
       SUM(NYBox02) NYBox02, 
       SUM(NYBox03) NYBox03, 
       SUM(NYBox04) NYBox04,  
       SUM(NYBox05) NYBox05, 
       SUM(NYBox06) NYBox06, 
       SUM(NYBox07) NYBox07, 
       SUM(NYBox08) NYBox08, 
       SUM(NYBox09) NYBox09,
       SUM(NYBox10) NYBox10,
       SUM(NYBox11) NYBox15a,
       SUM(NYBox12) NYBox15b,

 	---the following boxes match those on the form
       SUM(a.S4Future05) NYBox13,
       SUM(a.S4Future06) NYBox14,
       Max(v.User1) as VendorUser1, Max(v.User2) as VendorUser2, Max(v.User3) as VendorUser3, Max(v.User4) as VendorUser4, 
       Max(v.User5) as VendorUser5, Max(v.User6) as VendorUser6, Max(v.User7) as VendorUser7, Max(v.User8) as VendorUser8       
FROM vp_1099CpnyInfo vc INNER JOIN AP_Balances a ON vc.CpnyID = a.CpnyID
                        INNER JOIN Vendor v      ON a.VendID = v.VendID
WHERE (v.Vend1099 = 1)
GROUP BY vc.RI_ID, vc.Master_Fed_ID, v.VendId
GO
