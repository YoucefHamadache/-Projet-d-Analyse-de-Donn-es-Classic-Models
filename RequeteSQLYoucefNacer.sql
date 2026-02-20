/* Ici vous retrouverez toutes nos requetes SQL */


/* Dans ce filtre SQL nous avons additionné les quantités de vendue au cours des jours. Nous avons ensuite regroupé toutes les ventes effectuer par jours 

SELECT 
orders.orderDate as Order_Date,
sum(quantityOrdered) as Quantity_Ordered
FROM classicmodels.orders
JOIN classicmodels.orderdetails ON orders.orderNumber = orderdetails.orderNumber
group by orderDate;

*/


/* Dans ce filtre SQL nous avons compter le nombre de numéros de clients, c'est à dire le nombre de client. Nous les avons ensuite regroupé par pays afin d'avoir la part de marché dans chaque Pays

SELECT classicmodels.customers.country as Country,
count(classicmodels.customers.customerNumber) as Customer_Number
FROM classicmodels.customers
GROUP BY customers.country;

*/


/* Dans ce filtre nous avons calculer le chiffre d'affaire par pays. Ca qui nous a permit de faire les graphique de la page 2 dans le Power BI. 

SELECT 
classicmodels.customers.country AS Country,
sum(classicmodels.orderdetails.priceEach * classicmodels.orderdetails.quantityOrdered) AS CA_Country
FROM classicmodels.customers
JOIN classicmodels.orders
ON classicmodels.customers.customerNumber = classicmodels.orders.customerNumber
JOIN classicmodels.orderdetails
ON classicmodels.orders.orderNumber = classicmodels.orderdetails.orderNumber
GROUP BY customers.country;

*/

/* Ici nous avons calculer les le chiffre d'affaire mais en fonction des jours, ce qui nous permit les KPI de la première page. 

SELECT 
sum(classicmodels.orderdetails.quantityOrdered * classicmodels.orderdetails.priceEach) as CA,
classicmodels.orders.orderDate as Date_CA
FROM classicmodels.orderdetails
JOIN classicmodels.orders ON classicmodels.orderdetails.orderNumber = classicmodels.orders.orderNumber
group by Date_CA;

*/

/* Ici nous avons calculer les quantités vendue par produit, nous les avons regroupé par catégorie de produit. Nous les avons ensuite regroupé par date.
 
SELECT 
classicmodels.orders.orderDate AS Date_Order, 
SUM(classicmodels.orderdetails.quantityOrdered) AS Quantity,
classicmodels.customers.country AS Country
FROM classicmodels.orders 
JOIN classicmodels.orderdetails 
ON classicmodels.orders.orderNumber = classicmodels.orderdetails.orderNumber
JOIN classicmodels.customers 
ON classicmodels.orders.customerNumber = classicmodels.customers.customerNumber
GROUP BY classicmodels.orders.orderDate, classicmodels.customers.country;

*/

/* Ce script nous a permit d'effectuer le graphique des duré moyenne de livraison, il fait la différence entre la date de la commance et la date de la réception du colis

SELECT 
classicmodels.offices.officeCode AS Bureau,
classicmodels.offices.city AS Ville,
AVG(DATEDIFF(classicmodels.orders.shippedDate, classicmodels.orders.orderDate)) AS DureeMoyenneEnJours
FROM classicmodels.offices
JOIN classicmodels.employees ON classicmodels.offices.officeCode = classicmodels.employees.officeCode
JOIN classicmodels.customers ON classicmodels.employees.employeeNumber = classicmodels.customers.salesRepEmployeeNumber
JOIN classicmodels.orders ON classicmodels.customers.customerNumber = classicmodels.orders.customerNumber
WHERE classicmodels.orders.shippedDate AND classicmodels.orders.orderDate 
GROUP BY classicmodels.offices.officeCode
ORDER BY classicmodels.offices.officeCode;

*/

/* Ce script nous a permit d'effectuer le ratio de rentabilité de chaque modele vendue par l'entreprise.

SELECT 
classicmodels.products.productName AS Modele,
AVG((classicmodels.orderdetails.priceEach - classicmodels.products.buyPrice) / classicmodels.orderdetails.priceEach) AS RatioRentabiliteProduit
FROM classicmodels.orderdetails
JOIN classicmodels.products ON classicmodels.orderdetails.productCode = classicmodels.products.productCode
GROUP BY classicmodels.products.productName
ORDER BY RatioRentabiliteProduit DESC;

*/

/* Ce script nous a permit d'effectuer le dernier tableau de notre Power BI, ici on na effectuer le calcul du chiffre d'afffaire par employé, et on également effectuer le calcul du nombre de ventes
/* enregistrer par chaque employé sur les 3 ans. On a également fais en sorte de faire apparaitre le numéros de l'office dans laquelle apparait l'employé et le prénom ainsi que le nom de celui-ci.

SELECT 
classicmodels.offices.officeCode,
classicmodels.offices.city AS office_city,
classicmodels.employees.employeeNumber,
CONCAT(classicmodels.employees.firstName, ' ', classicmodels.employees.lastName) AS employee_name,
COUNT(DISTINCT classicmodels.orders.orderNumber) AS total_ventes,
SUM(classicmodels.orderdetails.quantityOrdered * classicmodels.orderdetails.priceEach) AS chiffre_affaires,
(SUM(classicmodels.orderdetails.quantityOrdered * classicmodels.orderdetails.priceEach) / 
COUNT(DISTINCT classicmodels.orders.orderNumber)) AS ratio_performance_vente    
FROM classicmodels.employees
JOIN classicmodels.offices 
ON classicmodels.employees.officeCode = classicmodels.offices.officeCode
JOIN classicmodels.customers 
ON classicmodels.employees.employeeNumber = classicmodels.customers.salesRepEmployeeNumber
JOIN classicmodels.orders 
ON classicmodels.customers.customerNumber = classicmodels.orders.customerNumber
JOIN classicmodels.orderdetails 
ON classicmodels.orders.orderNumber = classicmodels.orderdetails.orderNumber
GROUP BY classicmodels.offices.officeCode, 
classicmodels.employees.employeeNumber
ORDER BY chiffre_affaires DESC;

*/

/* Ce script SQL nous a permit d'effectuer la Treemap, ce qui nous a permit de voir la répartition des ventes sur les 3 ans. Ici on somme la quantité vendue qu'on regroupe par la suite en catégorie

SELECT 
classicmodels.productlines.productLine AS Categorie,
SUM(classicmodels.orderdetails.quantityOrdered) AS NombreDeVentes
FROM classicmodels.orderdetails
JOIN classicmodels.products ON classicmodels.orderdetails.productCode = classicmodels.products.productCode
JOIN classicmodels.productlines ON classicmodels.products.productLine = classicmodels.productlines.productLine
GROUP BY classicmodels.productlines.productLine
ORDER BY NombreDeVentes DESC;
 
*/

/* Ce sript nous a permit d'effectuer le graphique correspondant aux Prix moyen des commandes par pays, il effectue une moyenne de la commande moyenne faite par les clients dans chaque pays. 

SELECT 
classicmodels.customers.country AS Pays,
AVG(classicmodels.orderdetails.priceEach * classicmodels.orderdetails.quantityOrdered) AS PrixMoyenCommande
FROM classicmodels.orders
JOIN classicmodels.customers ON classicmodels.orders.customerNumber = classicmodels.customers.customerNumber
JOIN classicmodels.orderdetails ON classicmodels.orders.orderNumber = classicmodels.orderdetails.orderNumber
GROUP BY classicmodels.customers.country
ORDER BY PrixMoyenCommande DESC;

*/



/*Il reste plusieur autres requetes que nous n'avons pas mit dans ce fichier car nous souhaiterons vous les expliquer a l'oral si cela ne vous dérange. 
*/

